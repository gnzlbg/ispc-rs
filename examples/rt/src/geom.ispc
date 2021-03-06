#include "geom.ih"

export void make_sphere(uniform const Geometry * uniform * uniform out, uniform const Vec3f * uniform center,
		uniform float radius, uniform const Material * uniform mat)
{
	uniform Sphere * uniform sphere = uniform new uniform Sphere;
	sphere->geom.type = SPHERE;
	sphere->geom.material = mat;
	sphere->center = *center;
	sphere->radius = radius;
	*out = (uniform Geometry * uniform)sphere;
}
export void drop_sphere(const uniform Geometry * uniform geom){
	uniform Sphere * uniform sphere = (uniform Sphere * uniform)geom;
	delete sphere;
}
bool sphere_intersect(const uniform Geometry * uniform geom, Isect &isect, const Ray &ray){
	uniform Sphere * uniform sphere = (uniform Sphere * uniform)geom;
	Vec3f rs = ray.origin - sphere->center;
	const float a = dot(ray.dir, ray.dir);
	const float b = 2.0 * dot(rs, ray.dir);
	const float c = dot(rs, rs) - sphere->radius * sphere->radius;
	const float discrim = b * b - 4.0 * a * c;
	if (discrim > 0.f){
		float t = (-b - sqrt(discrim)) / (2.0 * a);
		if (t <= 0.f || t >= isect.t){
			t = (-b + sqrt(discrim)) / (2.0 * a);
		}
		if (t > 0.f && t < isect.t){
			isect.t = t;
			isect.p = ray.origin + ray.dir * t;
			isect.n = normalize(isect.p - sphere->center);
			return true;
		}
	}
	return false;
}

export void make_plane(uniform const Geometry * uniform * uniform out, uniform const Vec3f * uniform center,
		uniform const Vec3f * uniform normal, uniform const Material * uniform mat)
{
	uniform Plane * uniform plane = uniform new uniform Plane;
	plane->geom.type = PLANE;
	plane->geom.material = mat;
	plane->center = *center;
	plane->normal = *normal;
	*out = (uniform Geometry * uniform)plane;
}
export void drop_plane(const uniform Geometry * uniform geom){
	uniform Plane * uniform plane = (uniform Plane * uniform)geom;
	delete plane;
}
bool plane_intersect(const uniform Geometry * uniform geom, Isect &isect, const Ray &ray){
	uniform Plane * uniform plane = (uniform Plane * uniform)geom;
	float t = dot(plane->center - ray.origin, plane->normal) / dot(ray.dir, plane->normal);
	if (t > 0.f && t < isect.t){
		isect.t = t;
		isect.p = ray.origin + ray.dir * t;
		isect.n = plane->normal;
		return true;
	}
	return false;
}

